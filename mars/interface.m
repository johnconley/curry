function interface()

true = 1;
count = 1;
exit = 0;
files = ['per_poss_pos_1.csv'; 'per_poss_pos_2.csv'; 'per_poss_pos_3.csv'; 'per_poss_pos_4.csv'; 'per_poss_pos_5.csv'; 'per_poss.csv      '; 'totals_pos_1.csv  '; 'totals_pos_2.csv  '; 'totals_pos_3.csv  '; 'totals_pos_4.csv  '; 'totals_pos_5.csv  '; 'totals_pos.csv    '];
cellfiles = cellstr(files);

while true == 1
    positions(count) = input('Type the number corresponding for the position you want: \n 1-Point Guard \n 2-Shooting Guard \n 3-Small Forward \n 4-Power Forward \n 5-Center \n 6-All Positions \n');
    if(positions(count) ~= 1 && positions(count) ~= 2 && positions(count) ~= 3 && positions(count) ~= 4 && positions(count) ~= 5 && positions(count) ~= 6)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end

    data_types(count) = input('Type of data: \n 1-Per 100 Possession \n 2-Total \n');
    if(data_types(count) ~= 1 && data_types(count) ~= 2)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end

    stat_types(count) = input('Type of statistic: \n 1-Two-Point Percentage(2P%) \n 2-Total Rebounds(TRB) \n 3-Points(PTS) \n 4-Assists(AST) \n');
    if(stat_types(count) ~= 1 && stat_types(count) ~= 2 && stat_types(count) ~= 3 && stat_types(count) ~= 4)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end

    max_knots(count) = input('Enter max number of knots for forward pass 1 through 100 (suggested 20 or less)\n');
    if(max_knots(count) < 1 || max_knots(count) > 100 || mod(max_knots(count),1) ~= 0)
        disp('Incorrect Input: Please input an integer between 1 and 100 inclusive next time');
        exit = 1;
        break;
    end

    num_players(count) = input('Enter number of players used for training or 0 for all players \n');
    if(num_players(count) < 0 || mod(num_players(count),1) ~= 0)
        disp('Incorrect Input: Please input an integer greater than or equal to 0 next time');
        exit = 1;
        break;
    end

    count = count + 1;
    cont = input('Would you like to test another example? \n 1-Yes \n 2-No \n');
    if cont == 2
        true = 0;
    elseif cont ~= 1
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end
end

count = count - 1;

if exit ~= 1
    for i = 1:count
        filename = char(cellfiles(((data_types(i)-1) * 6) + positions(i)));

        if(positions(i) == 1)
            position = 'Point Guard';
        elseif(positions(i) == 2)
            position = 'Shooting Guard';
        elseif(positions(i) == 3)
            position = 'Small Forward';
        elseif(positions(i) == 4)
            position = 'Power Forward';
        elseif(positions(i) == 5)
            position = 'Center';
        else
            position = 'All Positions';
        end

        if(data_types(i) == 1)
            data_type = 'pos';
        else
            data_type = 'totals';
        end

        if(stat_types(i) == 1)
            stat_type = '2P%';
        elseif(stat_types(i) == 2)
            stat_type = 'TRB';
        elseif(stat_types(i) == 3)
            stat_type = 'PTS';
        else
            stat_type = 'AST';
        end

        max_value = max_knots(i);
        data_size = num_players(i);
        marsplot(data_type, stat_type, filename, max_value, position, data_size, 11);
    end
end

end
