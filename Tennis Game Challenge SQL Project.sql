--Question1.Create a data base that contains a Game, Score and Player tables with relationships.

--Creating table Player

CREATE TABLE Player(
ID VARCHAR(1) PRIMARY KEY,
Name varchar(4) NOT NULL,
LastName VARCHAR(9)
);

--Creating table Game

CREATE TABLE Game(
ID INT PRIMARY KEY NOT NULL,
Winner VARCHAR(1),
Date DATETIME NOT NULL,

CONSTRAINT fk_Game_Player_Id 
FOREIGN KEY (Winner)
REFERENCES Player (ID)
);

--Creating table Score

CREATE TABLE Score(
ID INT PRIMARY KEY ,
Game INT NOT NULL ,
Player VARCHAR(1) NOT NULL,
score INT NOT NULL,

CONSTRAINT fk_Score_Player_Id 
FOREIGN KEY (Player)
REFERENCES Player (ID),

CONSTRAINT fk_Score_Game_Id 
FOREIGN KEY (Game)
REFERENCES Game (ID)

);

--Inserting into table Game

INSERT INTO Game VALUES(1,'A' ,2017-01-02),
                        (2,'A',2016-05-06),
						(3,'B',2017-12-15),
						(4,'D',2016-05-06);

--Inserting into table Player

INSERT INTO Player VALUES('A','Phil','Watertank'),
                             ('B','Eva','Smith'),
				             ('C','John','Wick'),
				             ('D','Bill','Bull'),
				             ('E','Lisa','Owen');
 
		ALTER TABLE Score NOCHECK CONSTRAINT ALL;
 
--Inserting into table Score
				
 INSERT INTO dbo.Score VALUES (1,1,'A',11),
                              (2,1,'B',7),
				              (3,2,'A',15),
				              (4,2,'C',13),
				              (5,3,'B',11),
				              (6,3,'D',9),
				              (7,4,'D',11),
				              (8,4,'A',5),
				              (9,5,'A',11),
				              (10,6,'B',11),
				              (11,6,'C',2),
				              (12,6,'D',5);


ALTER TABLE Score CHECK CONSTRAINT ALL;


--Question 2. Show the average score of each player,even if they didn't play any games.
--Solution

SELECT P.ID,
	P.NAME,
	AVG(SCORE) AVERAGESCORE
FROM SCORE S
LEFT JOIN PLAYER P ON S. PLAYER = P.ID
GROUP BY P.ID,
	NAME;


--Question 3a. The score table is corrupted: a game can only have two players (not more, not less).
--write a query that identifies and only shows the valid games and their winner.
--Solution

SELECT DISTINCT S. GAME,
	G. WINNER
FROM SCORE S
INNER JOIN GAME G ON S. GAME = G.ID;


--Question 3b. As an additional challenge, display the winner's score. The condition above should still apply.
--Solution

SELECT DISTINCT S. GAME,
	G. WINNER,
	MAX (S. SCORE) WINNER_SCORE
FROM SCORE S
INNER JOIN GAME G ON S. GAME = G.ID
GROUP BY S. GAME,
G.WINNER ;


--Question 4.Show the score of player "Phil watertank" fOr games that he lost.
--Solution

SELECT TOP(1) G.ID,
	P.NAME,
	P.LASTNAME,
	S.SCORE
FROM SCORE S
JOIN GAME G ON G.ID = S.GAME
JOIN PLAYER P ON S.PLAYER = P.ID
WHERE P.NAME = 'Phil'
	AND P.LASTNAME = 'Watertank'
ORDER BY SCORE;

--Question 5: The two following queries return the same result. Why and what is the difference?
--Query 1:
Select * from Player 
left join Score on Score.Player = Player.ID 
where Score.Player is not null
--Query 2:
Select * from Player
right join Score on Score.Player = Player.ID and Score.Player is not null
where Score.Player is not null

--Solution

--They returned the same result because the NOT NULL Value in Query 1 enables the left join to
--function as an Inner join and also eliminated the null values.

--The difference between the two queries is that Query 2 can still generate the same result without 
--a where condition While Query 1 can only generate the same result when there is a where condition.


--Question 6:
--The two following queries return the players which have not played any games. In your opinion, which 
--one is the best and why? Discuss.
--Query 1:
Select Distinct Player.ID, Player.Name, Player.LastName from Player
left join Score on Score.Player = Player.ID
where Score.Player is null
--Query 2:
Select Player.ID, Player.Name, Player.LastName from Player
where Player.ID not in (select distinct Score.Player from Score)

--Solution

--Query 2 is the best.
--This is because Subqueries divide the complex query into isolated parts
--so that a complex query can be broken down into a series of logical steps.
--In this case the query 2 is broken down into simpler and neater steps in other
--to make it easy to read.


--Question 7: Show the list of player combinations who have never played together. 
--Solution

SELECT P1.ID AS PLAYER1,
    P2.ID PLAYER2
FROM PLAYER P1,
    PLAYER P2
WHERE P1.ID != P2.ID
EXCEPT
SELECT P1.PLAYER AS PLAYER1,
    P2.PLAYER AS PLAYER2
FROM SCORE P1,
    SCORE P2;

















