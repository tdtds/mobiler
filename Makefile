NAME=mobiler
VERSION=`ruby -rmobiler -e 'puts MOBILER_VERSION'`
PKG=$(NAME)-$(VERSION).tar.gz
REMOVE=Makefile mobiler.conf cgi/.htaccess cgi/mobiler-cgi.conf CVS cgi/CVS cgi/erb/CVS filter/CVS conf/dummy conf/CVS

pkg:
	cvs co $(NAME)
	mv $(NAME) $(NAME)-$(VERSION)
	cd $(NAME)-$(VERSION); rm -rf $(REMOVE); cd ..
	tar zcvf $(PKG) $(NAME)-$(VERSION)
	rm -r $(NAME)-$(VERSION)
	scp $(PKG) spc:htdocs/software/archive/
