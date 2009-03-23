#
# URLCutFilter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001,2002
# You can redistribute it and/or modify it under the same term as GPL2.
#
class URLCutFilter < Filter
	def URLCutFilter::description
		[
			'URLCutFilter',
			'URL���å�',
			'��ʸ���URL���(URL)�פȤ���ʸ������֤������ޤ���'
		]
	end

	def body_filter( body )
		body.gsub( %r{(http|https|ftp)://[\(\)%#!/0-9a-z_$@.&+-,'"*=;?:~-]+}i, '(URL)' )
	end
end

