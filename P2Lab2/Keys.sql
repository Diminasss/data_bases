-- Создание Primary Key
ALTER TABLE `choirmusic`.`choirmember`
MODIFY COLUMN Memberid INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (Memberid);

ALTER TABLE `choirmusic`.`composor`
MODIFY COLUMN Composorid INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (Composorid);

ALTER TABLE `choirmusic`.`work`
MODIFY COLUMN workid INT NOT NULL AUTO_INCREMENT,
ADD PRIMARY KEY (workid);

ALTER TABLE `choirmusic`.`musicalwork`
MODIFY COLUMN Musicid INT NOT NULL AUTO_INCREMENT,
MODIFY COLUMN Workid INT NOT NULL,
MODIFY COLUMN Composorid INT NOT NULL,
ADD PRIMARY KEY (Musicid);

ALTER TABLE `choirmusic`.`checkout`
MODIFY COLUMN Checkoutid INT NOT NULL AUTO_INCREMENT,
MODIFY COLUMN Memberid INT NOT NULL,
MODIFY COLUMN Workid INT NOT NULL,
MODIFY COLUMN Composorid INT NOT NULL,
ADD PRIMARY KEY (Checkoutid);

-- Создание Foreign Key
ALTER TABLE `choirmusic`.`checkout`
ADD CONSTRAINT fk_memberid_checkout
FOREIGN KEY (Memberid) REFERENCES `choirmusic`.`choirmember`(Memberid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `choirmusic`.`checkout`
ADD CONSTRAINT fk_workid_checkout
FOREIGN KEY (Workid) REFERENCES `choirmusic`.`work`(workid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `choirmusic`.`checkout`
ADD CONSTRAINT fk_composorid_checkout
FOREIGN KEY (Composorid) REFERENCES `choirmusic`.`composor`(Composorid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `choirmusic`.`musicalwork`
ADD CONSTRAINT fk_workid_musicalwork
FOREIGN KEY (Workid) REFERENCES `choirmusic`.`work`(workid)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE `choirmusic`.`musicalwork`
ADD CONSTRAINT fk_composorid_musicalwork
FOREIGN KEY (Composorid) REFERENCES `choirmusic`.`composor`(Composorid)
ON DELETE CASCADE
ON UPDATE CASCADE;