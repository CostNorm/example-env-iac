from fastapi import FastAPI
import time
import random
import uvicorn

app = FastAPI()

@app.get("/")
def read_root():
    delay = random.uniform(0, 3)
    time.sleep(delay)
    return {"message": f"Hello, World. response delayed by {delay} seconds"}

@app.get("/health")
def health():
    return {"status": "ok"}

if __name__ == '__main__':
    uvicorn.run(app, host="0.0.0.0", port=8000)