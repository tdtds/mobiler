#
# Basic Filter
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#
class BasicFilter < Filter
	def BasicFilter::description
		[
			'BasicFilter',
			'����ץ�ե��륿',
			';ʬ�ʥإå�����(Received,X-*,Resent-*)�������������Ԥȹ�Ƭ/�����ζ���������ޤ���BasicHeaderFilter��BasicBodyFilter���碌��ư���򤷤ޤ���'
		]
	end

	def header_filter( header )
		delete = false
		header.to_a.collect { |item|
			if /^(Received|Resent-.*?|X-.*?):/i =~ item then
				delete = true
				nil
			elsif /^>?From /i =~ item then
				delete = true
				nil
			elsif /^\s+/ =~ item and delete
				nil
			else
				delete = false
				item
			end
		}.join
	end

	def body_filter( body )
		body.to_a.collect { |item|
			if /^\s*$/ =~ item then
				nil
			elsif /^[ ��]*(.*?)[ ��]*$/ =~ item
				"#$1\n"
			else
				item
			end
		}.join
	end
end

