

CREATE OR REPLACE FUNCTION "Gym".is_trainer_fun() RETURNS trigger AS $$

DECLARE
    trainer_row "Gym".users%ROWTYPE= NULL;

    BEGIN

        SELECT * INTO trainer_row
        FROM "Gym".users user
        WHERE user.id=NEW.trainer;

        IF trainer_row.role=="trainer" THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS is_trainer ON "Gym".courses;
CREATE TRIGGER is_trainer
BEFORE INSERT OR UPDATE ON "Gym".courses
FOR EACH ROW
EXECUTE FUNCTION "Gym".is_trainer_fun()




CREATE OR REPLACE FUNCTION "Gym".is_slot_full_fun() RETURNS trigger AS $$

DECLARE
    slot_row "Gym".slots%ROWTYPE= NULL;
    current_occupation integer;

    BEGIN

        SELECT * INTO slot_row
        FROM "Gym".slots slot
        WHERE slot.id=NEW.slot;

        SELECT COUNT(*) INTO current_occupation
        FROM "Gym".weigthroom_reservations wr
        WHERE wr.slot = NEW.slot;

        IF current_occupation+1>slot_row.max_capacity THEN
            DELETE FROM "Gym".reservations r
            WHERE r.reservation_id = NEW.reservation_id;
            RETURN NULL;
        ELSE
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS is_slot_full ON "Gym".weigthroom_reservations;
CREATE TRIGGER is_slot_full
BEFORE INSERT OR UPDATE ON "Gym".weigthroom_reservations
FOR EACH ROW
EXECUTE FUNCTION "Gym".is_slot_full_fun()


CREATE OR REPLACE FUNCTION "Gym".is_lesson_full_fun() RETURNS trigger AS $$

DECLARE
    lesson_row "Gym".lessons%ROWTYPE= NULL;
    current_occupation integer;

    BEGIN

        SELECT * INTO lesson_row
        FROM "Gym".lessons lesson
        WHERE lesson.id=NEW.lesson;

        SELECT COUNT(*) INTO current_occupation
        FROM "Gym".lesson_reservations lr
        WHERE lr.lesson = NEW.lesson;

        IF current_occupation+1>lesson_row.max_partecipants THEN
            DELETE FROM "Gym".reservations r
            WHERE r.id = NEW.reservation_id;
            RETURN NULL;
        ELSE
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS is_lesson_full ON "Gym".lesson_reservations;
CREATE TRIGGER is_lesson_full
BEFORE INSERT OR UPDATE ON "Gym".lesson_reservations
FOR EACH ROW
EXECUTE FUNCTION "Gym".is_lesson_full_fun()
