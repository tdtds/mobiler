#
# Insert Subject Filter $Revision: 1.2 $
#
# Copyright (C) All right reserved by TADA Tadashi <sho@spc.gr.jp> 2001
# You can redistribute it and/or modify it under the same term as GPL2.
#					2001/04/05	update		a.k <akira@spc.gr.jp>
#
class InsertSubjectFilter < Filter
	def InsertSubjectFilter::description
		[
			'InsertSubjectFilter',
			'本文にSubjectを挿入する',
			'ヘッダのSubjectを見せてくれない携帯電話のメールのために、Subjectを本文の先頭に挿入します。'
		]
	end

	def header_filter( header )
		@subj = '(No Title)'
		isSubject	=	false
		subject		=	''
		header.to_a.collect { |item|
			if	/^Subject:\s(.*)/i =~ item then
				isSubject = true
				subject	=	$1
			elsif	/^\s+(.*)/ =~ item and isSubject
				subject	+=	$1
			else
				isSubject	=	false
				nil
			end
		}.join
		@subj =	NKF::nkf('-eJ',subject)
		header
	end

	def body_filter( body )
		"Sub:#{@subj}\n#{body}"
	end
end
