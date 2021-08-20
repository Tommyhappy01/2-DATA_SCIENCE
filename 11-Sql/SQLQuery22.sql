ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)
ON UPDATE NO ACTION -- update işlemlerinde herhangi bir değişiklik yapma
ON DELETE NO ACTION -- delete işlemlerinde aynı değişikliği uygula

ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID) REFERENCES Book.Author (Author_ID)
ON UPDATE NO ACTION -- update işlemlerinde herhangi bir değişiklik yapma
ON DELETE NO ACTION -- delete işlemlerinde aynı değişikliği uygula


ALTER TABLE Book.Book_Author ADD CONSTRAINT FK_Book2 FOREIGN KEY (Book_ID) REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE CASCADE
