# שלב 1 - בניית התמונה עם Python
FROM python:3.9-alpine as builder

# התקנת התלויות
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# שלב 2 - בניית התמונה הסופית
FROM python:3.9-alpine

# העתקת התלויות מהשלב הראשון
COPY --from=builder /usr/local/lib/python3.9 /usr/local/lib/python3.9
COPY --from=builder /usr/local/bin /usr/local/bin

# העתקת הקבצים הנדרשים
COPY app.py .
COPY templates/ templates/

# יצירת ווליום
VOLUME ["/data"]

# משתני סביבה
ENV NOTES_FILE=/data/notes.json
ENV APP_NAME="Docker Notes App"

# פורט
EXPOSE 5000

# בדיקת בריאות
HEALTHCHECK CMD curl --fail http://localhost:5000/ || exit 1

# הרצת האפליקציה
CMD ["python", "app.py"]
