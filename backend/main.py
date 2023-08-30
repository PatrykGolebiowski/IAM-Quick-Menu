import uvicorn

from typing import Union
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from router.graph import router as graph_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:9300"],  # Add the origin of your Vue.js app
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"Hello": "World"}


app.include_router(graph_router)
if __name__ == "__main__":
    uvicorn.run(app="main:app", port=9000, reload=True)