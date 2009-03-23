#!/home/spc/bin/ruby -Ke

require 'mobiler-cgi'

def all_filters
	desc = []
	Dir::glob( "#{MOBILER_PATH}/filter/*Filter.rb" ).sort.each do |f|
		eval( "require '#{f}'" )
		eval( "desc = #{File::basename( f, '.rb' )}::description" )
		yield desc[0], desc[1], desc[2]
	end
end

def current_filters
	$mobiler.filters do |filter| yield filter end
end

@cgi = CGI::new
@user = @cgi.remote_user
@conf = @cgi['conf'][0]
begin
	raise StandardError, 'no conf file' if not @conf or @conf.empty?
	@conf = @user + '/' + @conf if @user

	conf_file = "#{MOBILER_PATH}/conf/#{@conf}.conf"
	if not File::exist?( conf_file ) then
		@filters = []
		$split_size = 100000
		$split_limit = 10
		File::open( conf_file, 'w' ) do |f|
			f.print eval_eruby( 'confsave.rconf' )
		end
	end
	$mobiler = Mobiler::new( @conf, MOBILER_PATH )
	print @cgi.header( {'type' => 'text/html', 'charset' => 'EUC-JP' } )
	print eval_rhtml( 'filterlist.rhtml', "Mobiler: Filter List in #{@conf}" )
rescue
	$stderr.puts $!
	$stderr.puts $@.join( "\n" )
	print @cgi.header( {'Location' => 'conflist.cgi'} )
end

