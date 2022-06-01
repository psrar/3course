select s.name as sname, t.name as tname from t_pair p
left join t_subject s on p.subject = s.id
left join t_teacher t on p.teacher = t.id
join t_dayshedule d on p.dayshedule = d.id
 join t_weekshedule w on d.weekshedule = w.id
 join t_group g on w.groupid = g.id
where g.groupname = 'ТИП-61';

-- CREATE OR REPLACE FUNCTION getShedule(selectedGroup varchar)
--   RETURNS TABLE (sname varchar   
--                , tname varchar)
--   LANGUAGE plpgsql AS
-- $func$
-- BEGIN
--    RETURN QUERY
--    select s.name as sname, t.name, p.room as tname from t_pair p
-- left join t_subject s on p.subject = s.id
-- left join t_teacher t on p.teacher = t.id
-- join t_dayshedule d on p.dayshedule = d.id
--  join t_weekshedule w on d.weekshedule = w.id
--  join t_group g on w.groupid = g.id
-- where g.groupname = selectedGroup;
-- END
-- $func$;

-- CREATE OR REPLACE FUNCTION getSubjects(selectedGroup varchar)
--   RETURNS TABLE (id int   
--                , name varchar)
--   LANGUAGE plpgsql AS
-- $func$
-- BEGIN
--    RETURN QUERY
--    select distinct s.* from t_weekshedule w, t_group g,
-- t_dayshedule d, t_pair p, t_subject s
-- where g.groupname = selectedGroup and w.groupid = g.id
-- and d.weekshedule = w.id and p.dayshedule = d.id
-- and s.id = p.subject order by s.name;
-- END
-- $func$;