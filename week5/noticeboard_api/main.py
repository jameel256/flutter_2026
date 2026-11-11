from fastapi import FastAPI
from contextlib import asynccontextmanager
from datetime import datetime, timezone
from typing import Optional

from fastapi import Depends, FastAPI, HTTPException
from sqlmodel import Field, Session, SQLModel, create_engine, select


class NoticeCreate(SQLModel):
    title: str
    body: str = ""


class Notice(NoticeCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    created_at: datetime = Field(
        default_factory=lambda: datetime.now(timezone.utc)
    )


engine = create_engine(
    "sqlite:///noticeboard.db",
    connect_args={"check_same_thread": False},
)


def get_session():
    with Session(engine) as session:
        yield session


@asynccontextmanager
async def lifespan(app: FastAPI):
    SQLModel.metadata.create_all(engine)
    yield


app = FastAPI(title="Noticeboard API", lifespan=lifespan)
# app = FastAPI()

@app.get("/")
def root():
    return {"message": "My API is running"}
# get notices
@app.get("/notices", response_model=list[Notice])
def list_notices(session: Session = Depends(get_session)):
    statement = select(Notice).order_by(Notice.created_at.desc())
    return session.exec(statement).all()

# create a notice
@app.post("/notices", response_model=Notice, status_code=201)
def create_notice(data: NoticeCreate, session: Session = Depends(get_session)):
    notice = Notice.model_validate(data)
    session.add(notice)
    session.commit()
    session.refresh(notice)
    return notice

# get one notice
@app.get("/notices/{notice_id}", response_model=Notice)
def get_notice(notice_id: int, session: Session = Depends(get_session)):
    notice = session.get(Notice, notice_id)
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")
    return notice

# update a notice
@app.put("/notices/{notice_id}", response_model=Notice)
def update_notice(
    notice_id: int, data: NoticeCreate, session: Session = Depends(get_session)
):
    notice = session.get(Notice, notice_id)
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")
    notice.title = data.title
    notice.body = data.body
    session.add(notice)
    session.commit()
    session.refresh(notice)
    return notice

# delete a notice
@app.delete("/notices/{notice_id}", status_code=204)
def delete_notice(notice_id: int, session: Session = Depends(get_session)):
    notice = session.get(Notice, notice_id)
    if not notice:
        raise HTTPException(status_code=404, detail="Notice not found")
    session.delete(notice)
    session.commit()