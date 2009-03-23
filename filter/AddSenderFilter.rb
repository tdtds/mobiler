#
# Add Sender filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class AddSenderFilter < Filter
	def AddSenderFilter::description
		[
			'AddSenderFilter',
			'�إå��ˡ�Sender�פ��ɲä���',
			'Sender���Ĥ��Ƥ��ʤ��ȳ����ؤΥ᡼����ۿ����Ƥ���ʤ��ե����䥦������ʤɤؤ��к��˻Ȥ��ޤ����ѥ�᥿�ˤ�Sender�����ꤹ��᡼�륢�ɥ쥹����ꤷ�Ƥ���������'
		]
	end

	def initialize( *opt )
		super
		raise FilterError::new( 'AddSender: no sender mail address' ) if not @options[0]
		@sender = @options[0]
	end

	def header_filter( header )
		header.sub( /^Sender:(.*)$/, 'X-Sender:\1' ).concat( "Sender: #{@sender}\n" )
	end
end

