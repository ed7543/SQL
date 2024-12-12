/*Да се напишат DDL изразите за сите ентитетни множества кои се дефинирани во релациониот модел. Дополнително, потребно е да бидат исполнети следните барања:
Доколку јазикот на видео записот не е наведен, треба да се пополни со предефинирана вредност 'English'
Доколку процентот на попуст на премиум корисниците не е наведен, треба да се пополни со предефинирана вредност од 20 проценти
Полето за чување на телефонскиот број на корисникот потребно е да биде со максимална големина од 12 карактери
Коментар при препорака мора да биде внесен при што не смее да надмине големина од 250 карактери
Датумот на достапност на видео запис не може да биде пред датумот на премиера (може да бидат исти)
Оцената на препораката мора да биде од 1 до 5
Доколку некој видео запис се избрише од системот, препораките за тој запис треба да останат зачувани во базата на податоци со предефинирана вредност за наслов на записот 'Deleted'
При промена или бришење на корисникот, промената треба да се проследи и до табелата со премиум корисници.
Валидни препораки кои се внесуваат во базата мора да се по започнување на системот за стриминг на 7ми декември 2022 година
Регистрацијата на корисници во системот е дозволена од почеток на 2023 година до крајот на 2024 година
Забелешка: Табелите и атрибутите потребно е да ги креирате со ИСТИТЕ ИМИЊА и ИСТИОТ РЕДОСЛЕД како што е дадено во релациониот модел. За клучевите користете го податочниот тип TEXT. За надворешните клучеви за кои не е наведено 
ограничување за референцијален интегритет се претпоставува каскадно бришење/промена. За ограничувањата (check) потребно е да ги наведете како constraint по наведување на колоните а не во ист ред со истите. Пример наместо broj int 
check (broj > 0) треба да биде во формат broj int, constraint proverka check (broj > 0) . Конкретните вредности за датум дефинирајте ги како стринг (на пример "2021-01-20").*/ CREATE TABLE Korisnik (
  k_ime TEXT PRIMARY KEY,
  ime TEXT,
  prezime TEXT,
  tip TEXT,
  pretplata TEXT,
  datum_reg DATE,
  tel_broj VARCHAR(12),
  email TEXT,
  CONSTRAINT datum_reg_check CHECK (datum_reg >= '2023-01-01' AND datum_reg <= '2024-12-31')
);

CREATE TABLE Premium_korisnik (
  k_ime TEXT PRIMARY KEY,
  datum DATE,
  procent_popust INT DEFAULT 20,
  FOREIGN KEY (k_ime) REFERENCES Korisnik (k_ime)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Profil (
  k_ime TEXT,
  ime TEXT,
  datum DATE,
  PRIMARY KEY (k_ime, ime),
  FOREIGN KEY (k_ime) REFERENCES Korisnik (k_ime) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Video_zapis (
  naslov TEXT PRIMARY KEY,
  jazik TEXT DEFAULT 'English',
  vremetraenje INT,
  datum_d DATE,
  datum_p DATE,
  CONSTRAINT datum_check CHECK (datum_d >= datum_p)
);

CREATE TABLE Video_zapis_zanr (
  naslov TEXT,
  zanr TEXT,
  PRIMARY KEY (naslov, zanr),
  FOREIGN KEY (naslov) REFERENCES Video_zapis (naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Lista_zelbi (
  naslov TEXT,
  k_ime TEXT,
  ime TEXT,
  PRIMARY KEY (naslov, k_ime, ime),
  FOREIGN KEY (k_ime, ime) REFERENCES Profil (k_ime, ime) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (naslov) REFERENCES Video_zapis (naslov) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preporaka (
  ID TEXT PRIMARY KEY,
  k_ime_od TEXT,
  k_ime_na TEXT,
  naslov TEXT DEFAULT 'Deleted',
  datum DATE,
  komentar VARCHAR(250) not null,
  ocena INT,
  FOREIGN KEY (k_ime_od) REFERENCES Korisnik (k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (k_ime_na) REFERENCES Korisnik (k_ime) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (naslov) REFERENCES Video_zapis (naslov) ON DELETE SET DEFAULT ON UPDATE CASCADE,
  CONSTRAINT ocena_values CHECK (ocena IN (1, 2, 3, 4, 5)),
  CONSTRAINT datum_preporaka_check CHECK (datum > '2022-12-07')
);
