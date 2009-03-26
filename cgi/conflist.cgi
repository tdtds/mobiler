#!/usr/bin/ruby -Ke

require 'mobiler-cgi'

@cgi = CGI::new
@user = @cgi.remote_user
@conf = "#{MOBILER_PATH}/conf"
@conf += "/#{@user}" if @user
@confs = Dir::glob( "#{@conf}/*.conf" ).
		collect do |c| File::basename( c, '.conf' ) end
print @cgi.header( {'type' => 'text/html', 'charset' => 'EUC-JP' } )
print eval_rhtml( 'conflist.rhtml', 'Mobiler: Configuration List' )

