#
# �����᡼�� Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class CharMailFilter < Filter
	def CharMailFilter::description
		[
			'CharMailFilter',
			'�켰�����᡼��',
			'NTT DoCoMo��PHS�ǻȤ�������פʥ᡼�륵���ӥ��֤����᡼��פ�ž�����뤿��Υե��륿���Ƕ�Τ����᡼��ϴ������������褦�ʤΤǤ��Υե��륿�����פǤ��礦�������70ʸ�����¤ǡ��Ҥ餬�ʡ��������ʡ��ѿ����Ȱ����ε��椷���Ȥ��ʤ��Ť������᡼���б�ü���ѤǤ������BasicFilter���̤��Ƥ���������'
		]
	end

	def header_filter( header )
		@from = ''
		if /^From:\s+.*<+(.*)@.*>/ =~ header or /^From:\s+(.*?)@/ =~ header then
			@from = $1
		end
		header
	end

	def body_filter( body )
		body = NKF::nkf( '-EeZ1', body ).gsub( /[.,��������]/, ' ' )
		body.gsub!( /[^��-��-��A-z0-9?!#&()\\\[\]{}<>\/_ -]/, '_' )
		body.gsub!( /([�����������������������¤��ǤɤФӤ֤٤�])/, '\1��' )
		body.gsub!( /([�ѤԤפڤ�])/, '\1��' )
		body.gsub!( /([�����������������������¥ťǥɥХӥ֥٥�])/, '\1��' )
		body.gsub!( /([�ѥԥץڥ�])/, '\1��' )
		body.gsub!( /[\n\r]/, ' ' )
		body = cut( body, 70 - @from.length - 3 )
		body.gsub!( /[����]/, '' )
		"#{@from} #{body}\n"
	end

private
	def cut( str, limit )
		tmp = nil
		result = ''
		count = 0
		str.each_byte do |c|
			s = ''
			if tmp then
				s << tmp << c
				count += 1
				tmp = nil
			elsif c > 0x80
				tmp = c
			else
				s << c
				count += 1
			end
			break if count > limit
			result << s
		end
		result
	end
end

