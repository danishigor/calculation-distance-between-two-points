DROP FUNCTION IF EXISTS distance;

DELIMITER //
CREATE FUNCTION distance(
  latitudePoint1 DECIMAL(20, 18),
  longitudePoint1 DECIMAL(20, 18),
  latitudePoint2 DECIMAL(20, 18),
  longitudePoint2 DECIMAL(20, 18)
) RETURNS INTEGER
  BEGIN
    DECLARE earthRadius INTEGER DEFAULT 6372795;
    DECLARE pi DECIMAL(20, 15) DEFAULT 3.1415926535898;
    DECLARE lat1, lat2, long1, long2, cl1, cl2, sl1, sl2, delta, cdelta, sdelta, y, x, ad DECIMAL(20, 15);

    SET lat1 = latitudePoint1 * pi / 180;
    SET long1 = longitudePoint1 * pi / 180;
    SET lat2 = latitudePoint2 * pi / 180;
    SET long2 = longitudePoint2 * pi / 180;

    SET cl1 = COS(lat1);
    SET cl2 = COS(lat2);
    SET sl1 = SIN(lat1);
    SET sl2 = SIN(lat2);

    SET delta = long2 - long1;
    SET cdelta = COS(delta);
    SET sdelta = SIN(delta);

    SET y = SQRT(POW(cl2 * sdelta, 2) + POW(cl1 * sl2 - sl1 * cl2 * cdelta, 2));
    SET x = sl1 * sl2 + cl1 * cl2 * cdelta;
    SET ad = ATAN2(y, x);

    RETURN FLOOR(ad * earthRadius);
  END//
DELIMITER ;

/* Результат с тестовыми данными должен быть равен 153 метрам. */
SELECT distance(55.61939117182128, 37.50533624408178, 55.619593562991554, 37.507759266535956);
/**************** Рассчет расстояния между двумя точнками на карте. *****************/
