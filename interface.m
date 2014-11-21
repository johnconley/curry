function interface()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
true = 1;
count = 1;
exit = 0;
files = ['stats_per_poss_no1979_fixed_pos_1.csv'; 'stats_per_poss_no1979_fixed_pos_2.csv'; 'stats_per_poss_no1979_fixed_pos_3.csv'; 'stats_per_poss_no1979_fixed_pos_4.csv'; 'stats_per_poss_no1979_fixed_pos_5.csv'; 'stats_per_poss_no1979_fixed.csv      '; 'stats_totals_no1979_fixed_pos_1.csv  '; 'stats_totals_no1979_fixed_pos_2.csv  '; 'stats_totals_no1979_fixed_pos_3.csv  '; 'stats_totals_no1979_fixed_pos_4.csv  '; 'stats_totals_no1979_fixed_pos_5.csv  '; 'stats_totals_no1979_fixed.csv        '];
cellfiles = cellstr(files);
while(true == 1)
    result(count) = input('Type the number corresponding for the position you want: \n 1-Point Guard \n 2-Shooting Guard \n 3-Small Forward \n 4-Power Forward \n 5-Center \n 6-All Positions \n');
    if(result(count) ~= 1 && result(count) ~= 2 && result(count) ~= 3 && result(count) ~= 4 && result(count) ~= 5 && result(count) ~= 6)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end
    result2(count) = input('Type of data: \n 1-Per 100 Possession \n 2-Total \n');
    if(result2(count) ~= 1 && result2(count) ~= 2)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end
    result3(count) = input('Type of statistic: \n 1-Two-Point Percentage(2P%) \n 2-Total Rebounds(TRB) \n 3-Points(PTS) \n 4-Assists(AST) \n');
    if(result3(count) ~= 1 && result3(count) ~= 2 && result3(count) ~= 3 && result3(count) ~= 4)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end
    result4(count) = input('Enter max number of knots for forward pass 1 through 100 (suggested 20 or less)\n');
    if(result4(count) < 1 || result4(count) > 100 || mod(result4(count),1) ~= 0)
        disp('Incorrect Input: Please input an integer between 1 and 100 inclusive next time');
        exit = 1;
        break;
    end
    result5(count) = input('Enter number of players used for training or 0 for all players \n');
    if(result5(count) < 0 || mod(result5(count),1) ~= 0)
        disp('Incorrect Input: Please input an integer greater than or equal to 0 next time');
        exit = 1;
        break;
    end
    count = count + 1;
    result6 = input('Would you like to test another example? \n 1-Yes \n 2-No \n');
    if(result6 == 2)
        true = 0;
    elseif(result6 ~= 1)
        disp('Incorrect Input: Please input number according to your choice when you rerun it');
        exit = 1;
        break;
    end
end
count = count -1;
if(exit~= 1)
    for i=1:count
        filename = char(cellfiles(((result2(i)-1) * 6) + result(i)));
        if(result(i) == 1)
            position = 'Point Guard';
        elseif(result(i) == 2)
            position = 'Shooting Guard';
        elseif(result(i) == 3)
            position = 'Small Forward';
        elseif(result(i) == 4)
            position = 'Power Forward';
        elseif(result(i) == 5)
            position = 'Center';
        else
            position = 'All Positions';
        end
        if(result2(i) == 1)
            data_type = 'pos';
        else
            data_type = 'totals';
        end
        if(result3(i) == 1)
            stat_type = '2P%';
        elseif(result3(i) == 2)
            stat_type = 'TRB';
        elseif(result3(i) == 3)
            stat_type = 'PTS';
        else
            stat_type = 'AST';
        end
        max_value = result4(i);
        data_size = result5(i);
        marsplot(1, data_type, stat_type, filename, max_value, position, data_size);
    end
end
end

