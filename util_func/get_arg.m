function v = get_arg(varargs, name, default)
	% GET_ARG a helper function for parsing varargin where they are passed in as
	% my_function(..., 'name', value, ...)
	arg_idx = find(strcmpi(name, varargs));
	if arg_idx
		if length(varargs) < arg_idx + 1
			error('must specify a value for %s', name);
		end
		v = varargs{arg_idx + 1};
	else
		v = default;
	end
end