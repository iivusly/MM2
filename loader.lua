local env = getfenv()

env.require = function(URL)
	local URL = 'https://raw.githubusercontent.com/Calpico-Drink/MM2/master/src/' .. URL .. '.lua'
	return loadstring(game:HttpGet(URL, true), env)()
end

require('index')