Meteor.startup ()->
  Meteor.publish "sp500", ()->
    SP500.find()
