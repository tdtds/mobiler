#
# Insert From Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class InsertFromFilter < Filter
	def InsertFromFilter::description
		[
			'InsertFromFilter',
			'��ʸ��From����������',
			'�إå���From�򸫤��Ƥ���ʤ��������äΥ᡼��Τ���ˡ�From����桼��̾������ȴ���Ф�����ʸ����Ƭ���������ޤ���'
		]
	end

	def header_filter( header )
		@from = '(Unknown)'
		if /^From:\s+.*<+(.*)@.*>/ =~ header or /^From:\s+(.*?)@/ =~ header then
			@from = $1
		end
		header
	end

	def body_filter( body )
		"From:#{@from}\n#{body}"
	end
end

