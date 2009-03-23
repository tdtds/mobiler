#
# Set Return-Path filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class SetReturnPathFilter < Filter
	def SetReturnPathFilter::description
		[
			'SetReturnPathFilter',
			'�إå��ˡ�Return-Path�פ���ꤹ��',
			'�᡼���������˥��顼��ȯ���������ˡ����顼�᡼����ۿ����������ꤷ�ޤ������λ��꤬�ʤ��ȥ��顼��ȯ���Ԥ⤷���ϸ������ꤷ�Ƥ��ä�Return-Path���֤�ޤ��������줬�ޤ������˻��ꤷ�ޤ����ѥ�᥿�ˤϥ��顼�᡼���ۿ���Υ��ɥ쥹����ꤷ�ޤ���'
		]
	end

	def initialize( *opt )
		super
		raise FilterError::new( 'SetReturnPath: no mail address' ) if not @options[0]
		@path = @options[0]
	end

	def header_filter( header )
		header.sub( /^Return-Path:(.*)$/, 'X-Return-Path:\1' ).concat( "Return-Path: <#{@path}>\n" )
	end
end

