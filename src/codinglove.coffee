# Description:
#   Spread some of that codinglove goodness <https://thecodinglove.com>"
#
# Dependencies:
#   "cheerio": "0.7.0"
#   "he": "0.4.1"
#
# Configuration:
#   None
#
# Commands:
#   hubot [spread some] love - Displays a random codinglove meme
#   hubot [give me some] love - Displays a random codinglove meme
#
# Author:
#   dkelll

cheerio = require('cheerio')
he = require('he')

module.exports = (robot)->
  robot.respond /((give me|spread) some )?(joy|love)/i, (message)->
    send_meme message, 'https://thecodinglove.com', (text)->
      message.send text

send_meme = (message, location, response_handler)->
  get_random message, location, (stuff)->
    url = stuff
    console.log(url)

    message.http(url).get() (error, response, body)->
      return response_handler "Sorry, something went wrong" if error

      img_src = get_meme_image(body, ".blog-post-content img")
      txt = get_meme_txt(body, "h1.blog-post-title")

      response_handler "#{img_src}"
      response_handler "#{txt}"

get_meme_image = (body, selector)->
  $ = cheerio.load(body)
  try
    $(selector).first().attr('src').replace(/\.jpe?g/i, '.gif')
  catch
     $(".blog-post-content object").first().attr('data').replace(/\.jpe?g/i, '.gif')

get_meme_txt = (body, selector)->
  $ = cheerio.load(body)
  he.decode $(selector).first().text()

get_random = (message, location, resp_handler)->
  url = location

  message.http(url).get() (error, response, body)->
    return  "Crapppp" if error

    random_url = get_random_url(body, "div#mainNavbar a.nav-link")
    resp_handler "#{random_url}" 


get_random_url = (body, selector)->
  $ = cheerio.load(body)
  $(selector).first().attr('href')

