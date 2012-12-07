$(document).on "ready page:load", ->

  # Activate twitter bootstrap dropdown
  $('.dropdown-toggle').dropdown()

  # Activate twitter bootstrap carousel
  $('.carousel').carousel(
    interval: 5000
  )

  friends = $(".home-friends")
  if friends.length > 0
    friends.load '/friends', ->
      $('.masonry').masonry()

$(window).on "load resize", ->

  # Masonry
  $('.masonry').masonry()
