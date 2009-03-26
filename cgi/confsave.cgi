#!/usr/bin/ruby -Ke

require 'mobiler-cgi'

def filters
	0.upto( 9 ) do |i|
		filter = @cgi["filter#{i}"][0]
		param = @cgi["param#{i}"][0]
		if filter and filter.length > 0 then
			yield filter, param
		end
	end
end

def make_filter( klass, param )
	include Safe
	filter = nil
	begin
		eval( "require '#{klass}'" )
		Safe::safe do
			filter = eval( "#{klass}::new( #{param} )" )
		end
	rescue Exception
		#p,l,f,m = $!.to_s.split( ':', 4 )
		#@error += "#{klass}:#{m}\n"
		@error += "#{klass}: #$!\n"
	end
	filter
end

QUOTE = ['|', '"', '$', '!', ':', '@', '~']
def quote( str )
	return 'nil' if str.empty?
	QUOTE.each do |q|
		next if /#{Regexp::quote q}/ =~ str
		return "%q#{q}#{str}#{q}"
	end
end

@error = ''
@cgi = CGI::new
@user = @cgi.remote_user
@conf = @cgi['conf'][0]
begin
	raise StandardError, 'no conf file' if not @conf or @conf.empty?
	@conf = "#{@user}/#{@conf}" if @user
	$mobiler = Mobiler::new( @conf, MOBILER_PATH )
	@filters = []
	filters do |f,p|
		filter = make_filter( f, p )
		@filters << [filter, p] if filter
	end

	$split_size = @cgi['split_size'][0].to_i
	$split_limit = @cgi['split_limit'][0].to_i

	$split_size = 100000 if $split_size == 0
	$split_limit = 10 if $split_limit == 0

	if @error.empty? then # save conf
		conf = "#{MOBILER_PATH}/conf/#{@conf}.conf"
		File::delete( "#{conf}~" ) if File::exist?( "#{conf}~" )
		File::rename( conf, "#{conf}~" ) if File::exist?( conf )
		File::open( conf, 'w' ) do |f|
			f.print eval_eruby( 'confsave.rconf' )
		end
	end

	print @cgi.header( {'type' => 'text/html', 'charset' => 'EUC-JP' } )
	if @error.empty? then
		print eval_rhtml( 'confsave.rhtml', "Mobiler: #{@conf} saved" )
	else
		print eval_rhtml( 'confsave.error.rhtml', "Mobiler: #{@conf} save error" )
	end
rescue
	print @cgi.header( {'Location' => 'conflist.cgi'} )
end

