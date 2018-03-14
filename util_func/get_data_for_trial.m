function theta_spikes = get_data_for_trial(trial_data, start, offset)
	% because each trial may have a different length, they contribute different
	% amounts of data. The added complexity of using a 'start' index and an
	% 'offset' made me want to refactor this into its own function
	trial_length = size(trial_data, 1);
	all_indices = start:trial_length;
	left_shift = all_indices(1+abs(offset):end);
	right_shift = all_indices(1:end-abs(offset));

	if offset < 0
		spikes = trial_data(left_shift, 4);
		theta_rad = trial_data(right_shift, 1) * pi / 180;
	else
		spikes = trial_data(right_shift, 4);
		theta_rad = trial_data(left_shift, 1) * pi /180;
	end
	% theta is first col, spikes second col
	theta_spikes = [theta_rad, spikes];
end