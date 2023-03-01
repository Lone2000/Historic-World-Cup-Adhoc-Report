# Review The Tables Being Used 
SELECT * FROM projects.world_cups;

SELECT * FROM projects.world_cup_matches;

# Main Question: How have host countries performed in World Cups over time?

# Calculate total goals scored by each host country.
with cte2 AS(
SELECT wcm.Year as `Year`, 
(SELECT wc.`Host Country` FROM projects.world_cups as wc WHERE wcm.Year = wc.Year) as `Host Country`, 
SUM(`Home Goals`) as `Host Goal Scored`
FROM projects.world_cup_matches as wcm
GROUP BY `Year`,`Host Country`)

SELECT cte2.*, wc.`Goals Scored` as `Total Goal Scored`
FROM cte2
LEFT JOIN projects.world_cups as wc
ON cte2.`Year` = wc.`Year`;


# Calculate How many goals each host country conceeded
with cte as(
SELECT wcm.Year as `Year`, (SELECT wc.`Host Country` FROM projects.world_cups as wc WHERE wcm.Year = wc.Year) as `Host Country`, SUM(`Away Goals`) As `goals conceeded`
FROM projects.world_cup_matches as wcm
GROUP BY 1,2
)
SELECT cte.*
FROM cte;


# Final Query
# Calculate how many wins & loses each host country had.
with cte as (
SELECT wcm.Year as `Year`, (SELECT wc.`Host Country` FROM projects.world_cups as wc WHERE wcm.Year = wc.Year) as `Host Country`,
 COUNT(CASE WHEN `Home Goals` >= `Away Goals` THEN id END) AS `Matches Won`, COUNT(CASE WHEN `Home Goals` <= `Away Goals` THEN id END) AS `Matches Lost or Drew`,
 SUM(`Away Goals`) As `goals conceeded`,
 SUM(`Home Goals`) as `Host Goal Scored`
FROM projects.world_cup_matches as wcm
GROUP BY 1,2
)
SELECT cte.*,  wc.`Matches Played` , (`Matches Won` / wc.`Matches Played`) * 100 as `Win Rate`
FROM cte
LEFT JOIN projects.world_cups as wc
ON cte.`Year` = wc.`Year`;

  
  
  