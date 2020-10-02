setup:
	bundle install
	bundle exec pod install

deploy:
	firebase deploy
