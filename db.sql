CREATE DATABASE worldcup;
\c worldcup
CREATE TABLE teams (
team_id SERIAL PRIMARY KEY  not null,
name varchar(50) unique not null
);

CREATE TABLE games (
game_id SERIAL PRIMARY KEY  not null,
year int not null,
round varchar(50)  not null,
winner_id int not null,
opponent_id int not null,
	winner_goals int not null,
	 opponent_goals int not null,
	constraint fk_winner  foreign key (winner_id) references teams(team_id),
		constraint fk_opponent  foreign key (opponent_id) references teams(team_id)
);


