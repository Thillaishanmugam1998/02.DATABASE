create table international_teams
(
	team_id int,
	team_name varchar(50),
	team_rank int
)


select * from international_teams


insert into international_teams(team_id,team_name,team_rank)
Values(1,'India',1),
(2,'Australia',3),
(3,'England',2)


insert into international_teams values (4,'West Indians',5),(5,'South Africa',4)


alter table international_teams alter column team_name varchar(15)
alter table international_teams alter column team_name nvarchar(15)
alter table international_teams alter column team_name varchar(15) NOT NULL;
alter table international_teams alter column team_name NOT NULL;   -- Error 
alter table international_teams alter column team_name nvarchar(20) NULL;
alter table international_teams add  column team_type varchar(50) NULL  -- Error
alter table international_teams add  team_type varchar(50) NOT NULL  -- Error
alter table international_teams add   team_type varchar(50) NULL  -- Correct
alter table international_teams drop column team_type

exec sp_rename 'international_teams','i_teams'
exec sp_rename 'i_teams.team_rank', 'world_rank'

truncate table i_teams

select * from i_teams

Drop table i_teams