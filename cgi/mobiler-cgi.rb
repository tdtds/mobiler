#
# mobiler-cgi.rb $Revision: 1.3 $: User Interface of Mobiler via CGI
#

load 'mobiler-cgi.conf'

require 'cgi'
require 'nkf'
require 'erb/erbl'
require "#{MOBILER_PATH}/mobiler"

def eval_rhtml( file, title, bind = binding )
	body = File::readlines( 'header.rhtml' ).join + 
			File::readlines( file ).join +
			File::readlines( 'footer.rhtml' ).join
	ERbLight::new( body ).result( bind )
end

def eval_eruby( file, bind = binding )
	ERbLight::new( File::readlines( file ).join ).result( bind )
end

