function run_mars()

%marsplot(data_type, stat_type, filename, max_value, position, data_size)
marsplot('pos', '2P%', 'per_poss_pos_1.csv', 20, 'Point Guard', 100);
marsplot('pos', 'TRB', 'per_poss_pos_5.csv', 20, 'Center', 100);
marsplot('pos', 'PTS', 'per_poss_pos_2.csv', 20, 'Shooting Guard', 100);
marsplot('pos', 'AST', 'per_poss_pos_5.csv', 20, 'Center', 100);


end

