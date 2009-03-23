#
# Impress Watch filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class ImpressWatchFilter < Filter
	def ImpressWatchFilter::description
		[
			'ImpressWatchFilter',
			'����ץ쥹Watch���꡼��',
			'����ץ쥹��ȯ�Ԥ�Watch�᡼��ޥ����󥷥꡼���򥳥�ѥ��Ȥˤ���ե��륿�Ǥ���Subject��û�̤ȡ����𤪤�Ӥ��Τ餻�κ����Ԥʤ��ޤ���'
		]
	end

	def header_filter( header )
		header.sub( /^Subject:\s+\[(.).*? Watch.*?:(GOUGAI_)?\d{4}(.*?)\] .*$/, 'Subject: [\1W:\3]' )
	end

	def body_filter( body )
		body = NKF::nkf( '-XdEeZ -m0', body )
		body.gsub!( '��', ' ' )
		body.gsub!( /(-|=|��|��|��|��|��|��){2,}/, '--' )
		body.gsub!( / {2,}/, ' ' )
		body.gsub!( %r{(http|https|ftp)://[\(\)%#!/0-9a-zA-Z_$@.&+-,'"*=;?:~-]+}, '(URL)' )
		body.gsub!( /^\(.*\)$/, '' )
		body.gsub!( /\[��\]/, '' )
		body.gsub!( /^ ?\[Reported by (.*?)@.*\]/, "<\\1>\n--" )
		body.gsub!( /^\[Reported by (.*)]/, "<\\1>\n--" )
		body.gsub!( /�ǥ��꡼�䤸����/, '�䤸��' )
		body.gsub!( /�����������ȥ˥塼��/, 'DIGEST' )
		body.gsub!( /�����å��㡼�����ֺ����Υ�����/, '������' )
		body.gsub!( /^��INTERNET Watch���.*$/, '' )
		body.gsub!( /��$/, '' )
		body.gsub!( /(^��|��$)/, '' )
		body.gsub!( /\(IE\)/i, '' )
		body.gsub!( /Internet\s*Explorer/i, 'IE' )
		body.gsub!( /���󥿡��ͥåȡ�*�������ץ��顼*/i, 'IE' )
		body.gsub!( /Internet/i, 'INET' )
		body.gsub!( /���󥿡��ͥå�/, 'INET' )
		body.gsub!( /�ץ�Х�����/, 'ISP' )
		body.gsub!( /Sun Microsystems/, 'Sun' )
		body.gsub!( /�ǡ����١���/, 'DB' )
		body.gsub!( /���ץꥱ�������/, '���ץ�' )
		body.gsub!( /��COMPUTERWORLD TODAY��\(IDG���ߥ�˥��������\)����/, "<COMPWORLD>\n--" )
		body.gsub!( /�˥եƥ��������/, 'NIFTY' )
		body.gsub!( /�������ӥ�/, '�����ӥ�' )
		body.gsub!( /\(�����̿���\)/, "<����>\n--" )

		pr = false
		footer = false
		genre = nil
		prev = nil
		body.to_a.collect { |item|
			if /^$/ =~ item then
				nil
			elsif /^--��PR��.*--$/ =~ item then
				pr = !pr
				nil
			elsif /^��.*? Watch��WWW�����С�$/ =~ item
				footer = true
				nil
			elsif /���ܤ�����˭�٤ʥ˥塼����/ =~ item
				footer = true
				nil
			elsif pr or footer
				nil
			elsif genre
				if /^-/ =~ item then
					genre = 2
					nil
				elsif /^ / =~ item or genre == 1
					genre = nil
					prev = "\n" + item
				else
					genre = nil
					if prev == item then nil else prev = item end
				end
			else
				if /^\[(.*?)\]$/ =~ item
					item = '��' + $1.chomp + ' '
					genre = 1
				end
				if prev == item then nil else prev = item end
			end
		}.join
	end
end

