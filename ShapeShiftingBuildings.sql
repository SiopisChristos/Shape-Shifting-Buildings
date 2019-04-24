--1) SHAPE SHIFTING BUILDINGS

    --1.1) RESIDENT TABLE
    
        --1.1.1) CREATION OF RESIDENT TABLE
    
            CREATE TABLE RESIDENT (
                RESIDENT_ID NUMBER,
                RESIDENT_NAME CHAR(20),
                RESIDENT_EMAIL CHAR(30),
                RESIDENT_DOB DATE,
                RESIDENT_TELEPHONE NUMBER,
                CONSTRAINT RESIDENT_PK PRIMARY KEY (RESIDENT_ID)
            );
            /
            
    --1.2) BUILDING TABLE
    
        --1.2.1) BUDLING SHAPE OBJECT CREATION (INNER NESTED TABLE)

            CREATE TYPE BUILDING_SHAPE_OBJECT AS OBJECT(
                X NUMBER,
                Y NUMBER
            );
            /
    
        --1.2.2) DECLARATION OF BULDING SHAPE TYPE AS AS PART OF BUILDING SHAPE OBJECT
    
            CREATE TYPE BUILDING_SHAPE_TYPE AS TABLE OF BUILDING_SHAPE_OBJECT;
            /

        --1.2.3) BUILDING FEATURES OBJECT CREATION (OUTTER NESTED TABLE)

            CREATE TYPE BUILDING_FEATURES_OBJECT AS OBJECT(
                BUILDING_SHAPE BUILDING_SHAPE_TYPE,
                START_ DATE,
                STOP_ DATE,
                TEMPERATURE NUMBER,
                HUMIDITY NUMBER
            );
            /
    
        --1.2.4) DECLARATION OF BULDING FEATURES TYPE AS AS PART OF BUILDING FEATURES OBJECT
    
            CREATE TYPE BUILDING_FEATURES_TYPE AS TABLE OF BUILDING_FEATURES_OBJECT;
            /

        --1.2.5) CREATION OF BUILDING TABLE

            CREATE TABLE BUILDING(
                BUILDING_ID NUMBER,
                BUILDING_NAME CHAR(30),
                BUILDING_FEATURES BUILDING_FEATURES_TYPE,
                CONSTRAINT BUILDING_PK PRIMARY KEY (BUILDING_ID)
            )NESTED TABLE BUILDING_FEATURES STORE AS NT_BUILDING_FEATURES
                (NESTED TABLE BUILDING_SHAPE STORE AS NT_BUILDING_SHAPE);
            /
            
    --1.3) USAGE TABLE (FACT TABLE)
    
        --1.3.1) CREATION OF USAGE TABLE
        
            CREATE TABLE USAGE (
                USAGE_ID NUMBER,
                RESIDENT_ID NUMBER,
                BUILDING_ID NUMBER,
                USAGE_COST NUMBER,
                USAGE_START_DATE DATE,
                USAGE_STOP_DATE DATE,
                USAGE_TYPE NUMBER,
                CONSTRAINT USAGE_PK PRIMARY KEY (USAGE_ID),
                CONSTRAINT RESIDENT_FK FOREIGN KEY (RESIDENT_ID) REFERENCES RESIDENT(RESIDENT_ID),
                CONSTRAINT BUILDING_FK FOREIGN KEY (BUILDING_ID) REFERENCES BUILDING(BUILDING_ID)
            );
            /
            
--2) INSERTING VALUES INTO SCHEMA

    --2.1) INSERTING VALUES INTO RESIDENT TABLE
    
        BEGIN
            FOR loop_counter IN 1..1000 LOOP
                INSERT INTO "RESIDENT" (RESIDENT_ID,
                                        RESIDENT_NAME,
                                        RESIDENT_EMAIL,
                                        RESIDENT_DOB,
                                        RESIDENT_TELEPHONE)
                VALUES(loop_counter,
                       DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(5,20))),
                       DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(9,30))),
                       TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '1950-01-01','J') ,TO_CHAR(DATE '2018-04-17','J'))),'J'),
                       dbms_random.value(1111111111,9999999999)
                );
            END LOOP;
        COMMIT;
        END;
        /
        
    --2.2) INSERTING VALUES INTO BUILDING TABLE
        
        --2.2.1.1) HOUSE WITH ID = 1
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('1', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.1.2) HOUSE ID = 1 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..4 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '1') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.2.1) HOUSE WITH ID = 2

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('2', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.2.2) HOUSE ID = 2 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '2') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.3.1) HOUSE WITH ID = 3
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('3', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.3.2) HOUSE ID = 3 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '3') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.4.1) HOUSE WITH ID = 4

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('4', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.4.2) HOUSE ID = 4 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..8 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '4') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.5.1) HOUSE WITH ID = 5
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('5', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.5.2) HOUSE ID = 5 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..8 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '5') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.6.1) HOUSE WITH ID = 6

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('6', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.6.2) HOUSE ID = 6 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..8 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '6') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.7.1) HOUSE WITH ID = 7
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('7', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.7.2) HOUSE ID = 7 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..4 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '7') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.8.1) HOUSE WITH ID = 8

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('8', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.8.2) HOUSE ID = 8 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..9 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '8') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.9.1) HOUSE WITH ID = 9
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('9', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.9.2) HOUSE ID = 9 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '9') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.10.1) HOUSE WITH ID = 10

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('10', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.10.2) HOUSE ID = 10 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '10') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.11.1) HOUSE WITH ID = 11
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('11', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.11.2) HOUSE ID = 11 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..6 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '11') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.12.1) HOUSE WITH ID = 12

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('12', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.12.2) HOUSE ID = 12 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '12') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.13.1) HOUSE WITH ID = 13
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('13', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.13.2) HOUSE ID = 13 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..4 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '13') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.14.1) HOUSE WITH ID = 14

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('14', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.14.2) HOUSE ID = 14 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '14') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.15.1) HOUSE WITH ID = 15
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('15', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.15.2) HOUSE ID = 15 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..8 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '15') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.16.1) HOUSE WITH ID = 16

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('16', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.16.2) HOUSE ID = 16 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '16') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.17.1) HOUSE WITH ID = 17
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('17', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.17.2) HOUSE ID = 17 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..6 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '17') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.18.1) HOUSE WITH ID = 18

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('18', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.18.2) HOUSE ID = 18 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '18') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.19.1) HOUSE WITH ID = 19
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('19', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.19.2) HOUSE ID = 19 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..9 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '19') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.20.1) HOUSE WITH ID = 20

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('20', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.20.2) HOUSE ID = 20 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '20') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.21.1) HOUSE WITH ID = 21
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('21', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.21.2) HOUSE ID = 21 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '21') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /


        --2.2.22.1) HOUSE WITH ID = 22

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('22', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.22.2) HOUSE ID = 22 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..6 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '22') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.23.1) HOUSE WITH ID = 23
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('23', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.23.2) HOUSE ID = 23 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..8 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '23') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.24.1) HOUSE WITH ID = 24

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('24', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.24.2) HOUSE ID = 24 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '24') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.25.1) HOUSE WITH ID = 25
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('25', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.25.2) HOUSE ID = 25 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '25') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /


        --2.2.26.1) HOUSE WITH ID = 26

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('26', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.26.2) HOUSE ID = 26 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..7 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '26') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.27.1) HOUSE WITH ID = 27
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('27', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.27.2) HOUSE ID = 27 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..4 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '27') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.28.1) HOUSE WITH ID = 28

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('28', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.28.2) HOUSE ID = 28 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '28') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.29.1) HOUSE WITH ID = 29
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('29', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.29.2) HOUSE ID = 29 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..4 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '29') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /

        --2.2.30.1) HOUSE WITH ID = 30

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('30', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.03.2) HOUSE ID = 30 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..6 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '03') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
                    
        --2.2.311.1) HOUSE WITH ID = 31
    
            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('31', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.31.2) HOUSE ID = 31 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..5 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '31') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /


        --2.2.32.1) HOUSE WITH ID = 32

            INSERT INTO "BUILDING" (BUILDING_ID, BUILDING_NAME, BUILDING_FEATURES)
                VALUES ('32', DBMS_RANDOM.string('u',TRUNC(DBMS_RANDOM.value(10,30))),
                    BUILDING_FEATURES_TYPE(
                        BUILDING_FEATURES_OBJECT(
                        BUILDING_SHAPE_TYPE(
                            BUILDING_SHAPE_OBJECT(
                                dbms_random.value(0,100),
                                dbms_random.value(0,100)
                            )
                        ),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(-40,60),2), --CELCIUS
                        TRUNC(dbms_random.value(0,100),2)
                        )
                    )
                );
            /

        --2.2.32.2) HOUSE ID = 32 (REST CORNERS)
            
            BEGIN
                FOR loop_counter IN 2..6 LOOP
                    INSERT INTO TABLE (SELECT c.BUILDING_SHAPE
                       FROM TABLE(SELECT r.BUILDING_FEATURES
                                  FROM BUILDING r
                                  WHERE r.BUILDING_ID = '32') c)
                    VALUES (dbms_random.value(0,100),dbms_random.value(0,100));
                END LOOP;
            COMMIT;
            END;
            /
            
    --2.3) INSERTING VALUES INTO USAGE TABLE
    
        BEGIN
            FOR loop_counter IN 1..10000 LOOP
                INSERT INTO "USAGE" (USAGE_ID,
                                     RESIDENT_ID,
                                     BUILDING_ID,
                                     USAGE_COST,
                                     USAGE_START_DATE,
                                     USAGE_STOP_DATE,
                                     USAGE_TYPE)
                VALUES (loop_counter,
                        (SELECT * FROM (SELECT "RESIDENT".RESIDENT_ID FROM RESIDENT ORDER BY DBMS_RANDOM.VALUE)WHERE ROWNUM = 1),
                        (SELECT * FROM (SELECT "BUILDING".BUILDING_ID FROM BUILDING ORDER BY DBMS_RANDOM.VALUE)WHERE ROWNUM = 1),
                        TRUNC(dbms_random.value(0,100),4),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2000-01-01','J') ,TO_CHAR(DATE '2018-12-31','J'))),'J'),
                        TRUNC(dbms_random.value(0,100),4)
                        );
            END LOOP;
        COMMIT;
        END;
        /
        
--3) INTEGRITY RULES

    --3.1) INTEGRITY RULES IN NT_BUILDING_FEATURES

        --3.1.1) SWAP DATES IF BUILDING FEATURES START > BUILDING FEATURES STOP
                
            UPDATE /*+ NESTED_TABLE_GET_REFS */ "NT_BUILDING_FEATURES"
            SET START_ = STOP_, STOP_ = START_
            WHERE START_ > STOP_
            /
        
    --3.1) INTEGRITY RULES IN USAGE TABLE

        --3.1.1) SWAP DATES IF USAGE START DATE > USAGE STOP DATE
        
            DECLARE
            USAGE_START_DATE DATE;
            USAGE_STOP_DATE DATE;
            BEGIN
                UPDATE "USAGE"
                SET USAGE_START_DATE = USAGE_STOP_DATE, USAGE_STOP_DATE = USAGE_START_DATE
                WHERE USAGE_START_DATE > USAGE_STOP_DATE;
            END;
            /

--4) SQL QUERIES

    --4.1) How many times the building with name Altura has changed its shape during the year 2018?

        SELECT (SELECT COUNT(*) FROM TABLE(BB."BUILDING_SHAPE")) AS TIMES
        FROM "BUILDING" B, TABLE(B."BUILDING_FEATURES") BB
        WHERE B.BUILDING_NAME='Altura'
            AND BB.START_ >= '1/1/2018'
            AND BB.STOP_ <= '31/12/2018';
            
    --4.2) Which building changed its shape the maximum number of times?
              
        SELECT B.BUILDING_ID
        FROM "BUILDING" B, TABLE(B."BUILDING_FEATURES") BB
        WHERE (SELECT COUNT(*) 
               FROM TABLE(BB."BUILDING_SHAPE")) = (SELECT MAX(T.TIMES)
                                                   FROM (SELECT B.BUILDING_ID, (SELECT COUNT(*) 
                                                                                FROM TABLE(BB."BUILDING_SHAPE")) AS TIMES
                                                         FROM "BUILDING" B, TABLE(B."BUILDING_FEATURES") BB) T)
        GROUP BY B.BUILDING_ID;
        
    --4.3) What is the total number of days for each building that stayed in one specific shape when the temperature 
    --     was greater than 30 degrees Celsius and the humidity less than 50%?
    
        SELECT B.BUILDING_ID, SUM(TO_DATE(BB.STOP_) - TO_DATE(BB.START_)) AS DAYS
        FROM "BUILDING" B, TABLE(B."BUILDING_FEATURES") BB
        WHERE BB.TEMPERATURE > 30
            AND BB.HUMIDITY < 50
        GROUP BY B.BUILDING_ID;
 
    --4.4) Which building changed its shape although temperature and humidity remained the same?
        
        SELECT B1.BUILDING_ID
        FROM "BUILDING" B1, "BUILDING" B2, TABLE(B1."BUILDING_FEATURES") BB1, TABLE(B2."BUILDING_FEATURES") BB2
        WHERE B1.BUILDING_ID = B2.BUILDING_ID 
            AND BB1.TEMPERATURE = BB2.TEMPERATURE
            AND BB1.HUMIDITY = BB2.HUMIDITY
            AND BB1.START_ <> BB2.START_;

    --4.5) Who was the resident of building with name Altura and what was the shape (the coordinates) of this building on 1/1/2019?

        SELECT R.RESIDENT_NAME, BBB.X, BBB.Y
        FROM "RESIDENT" R, "USAGE" U, "BUILDING" B, TABLE(B."BUILDING_FEATURES") BB, TABLE (BB."BUILDING_SHAPE") BBB
        WHERE R.RESIDENT_ID = U.RESIDENT_ID
            AND B.BUILDING_ID = U.BUILDING_ID
            AND B.BUILDING_NAME = 'Altura'
            AND BB.START_ <= '1/1/2019'
            AND BB.STOP_ >= '1/1/2019';