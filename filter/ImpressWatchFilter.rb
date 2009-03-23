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
			'インプレスWatchシリーズ',
			'インプレス社発行のWatchメールマガジンシリーズをコンパクトにするフィルタです。Subjectの短縮と、広告およびお知らせの削除を行ないます。'
		]
	end

	def header_filter( header )
		header.sub( /^Subject:\s+\[(.).*? Watch.*?:(GOUGAI_)?\d{4}(.*?)\] .*$/, 'Subject: [\1W:\3]' )
	end

	def body_filter( body )
		body = NKF::nkf( '-XdEeZ -m0', body )
		body.gsub!( '　', ' ' )
		body.gsub!( /(-|=|■|┏|━|┓|┗|┛){2,}/, '--' )
		body.gsub!( / {2,}/, ' ' )
		body.gsub!( %r{(http|https|ftp)://[\(\)%#!/0-9a-zA-Z_$@.&+-,'"*=;?:~-]+}, '(URL)' )
		body.gsub!( /^\(.*\)$/, '' )
		body.gsub!( /\[写\]/, '' )
		body.gsub!( /^ ?\[Reported by (.*?)@.*\]/, "<\\1>\n--" )
		body.gsub!( /^\[Reported by (.*)]/, "<\\1>\n--" )
		body.gsub!( /デイリーやじうま/, 'やじ馬' )
		body.gsub!( /ダイジェストニュース/, 'DIGEST' )
		body.gsub!( /ウォッチャーが選ぶ今日のサイト/, 'サイト' )
		body.gsub!( /^■INTERNET Watchより.*$/, '' )
		body.gsub!( /■$/, '' )
		body.gsub!( /(^┃|┃$)/, '' )
		body.gsub!( /\(IE\)/i, '' )
		body.gsub!( /Internet\s*Explorer/i, 'IE' )
		body.gsub!( /インターネット・*エクスプローラー*/i, 'IE' )
		body.gsub!( /Internet/i, 'INET' )
		body.gsub!( /インターネット/, 'INET' )
		body.gsub!( /プロバイダー/, 'ISP' )
		body.gsub!( /Sun Microsystems/, 'Sun' )
		body.gsub!( /データベース/, 'DB' )
		body.gsub!( /アプリケーション/, 'アプリ' )
		body.gsub!( /『COMPUTERWORLD TODAY』\(IDGコミュニケーションズ\)特約/, "<COMPWORLD>\n--" )
		body.gsub!( /ニフティ株式会社/, 'NIFTY' )
		body.gsub!( /新サービス/, 'サービス' )
		body.gsub!( /\(時事通信社\)/, "<時事>\n--" )

		pr = false
		footer = false
		genre = nil
		prev = nil
		body.to_a.collect { |item|
			if /^$/ =~ item then
				nil
			elsif /^--☆PR☆.*--$/ =~ item then
				pr = !pr
				nil
			elsif /^●.*? WatchのWWWサーバー$/ =~ item
				footer = true
				nil
			elsif /より詳しく、豊富なニュースや/ =~ item
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
					item = '◆' + $1.chomp + ' '
					genre = 1
				end
				if prev == item then nil else prev = item end
			end
		}.join
	end
end

