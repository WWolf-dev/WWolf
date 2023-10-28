local function allowAce(allow)
	return allow == false and 'deny' or 'allow'
end

-- Adds the ace to the principal.
function ww.addAce(principal, ace, allow)
	if type(principal) == 'number' then
		principal = 'player.'..principal
	end

	ExecuteCommand(('add_ace %s %s %s'):format(principal, ace, allowAce(allow)))
end

-- Removes the ace from the principal.
function ww.removeAce(principal, ace, allow)
	if type(principal) == 'number' then
		principal = 'player.'..principal
	end

	ExecuteCommand(('remove_ace %s %s %s'):format(principal, ace, allowAce(allow)))
end