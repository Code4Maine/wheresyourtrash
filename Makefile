install:
	virtualenv -p python3 venv
	venv/bin/python setup.py install
	venv/bin/python manage.py migrate --noinput

deploy_deps:
	virtualenv -p python2 .ansible-venv
	.ansible-venv/bin/pip install ansible

deps:
	sudo apt-get install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk libxslt-dev libxml2-dev redis-server
	npm install bower
	

deps_mac:
	brew install libtiff libjpeg webp little-cms2 redis
	npm install bower

deps_freebsd:
	sudo pkg install jpeg tiff webp lcms2 freetype2 redis

test:
	rm -rf .tox
	detox

clean:
	rm -rf *.egg-info
	rm -rf build
	rm -rf dist

reset:
	$(MAKE) clean
	rm -rf venv
	rm -rf .ansible-venv

run:
	venv/bin/python manage.py runserver_plus 0.0.0.0:35000

tag-release:
	sed -i "/__version__/c\__version__ = '$(v)'" wheresyourtrash/__init__.py
	git add wheresyourtrash/__init__.py && git commit -m "Automated version bump to $(v)" && git push
	git tag -a release/$(v) -m "Automated release of $(v) via Makefile" && git push origin --tags

package:
	rm -rf build
	python setup.py clean
	python setup.py build sdist bdist_wheel

distribute:
	twine upload -s dist/wheresyourtrash-$(v)*

release:
	$(MAKE) tag-release
	$(MAKE) package
	$(MAKE) distribute

deploy:
	$(MAKE) deploy_deps
	ansible-playbook -i ansible/hosts --limit prod --tags deploy --extra-vars '{"app_version":"$(v)"}' ansible/webapp.yml
	ansible-playbook -i ansible/hosts --limit prod --tags deploy --extra-vars '{"app_version":"$(v)"}' ansible/workers.yml
