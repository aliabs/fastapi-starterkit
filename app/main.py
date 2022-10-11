"""
Primary FastPI ASGI application

"""
import logging

from fastapi import FastAPI
from fastapi.logger import logger
from starlette.middleware.cors import CORSMiddleware

from app.api.endpoints import api_routes
from app.cloud_logging.middleware import LoggingMiddleware
from app.cloud_logging.setup import setup_logging


def create_app():
    # Initialize FastAPI app
    app = FastAPI()

    # Enable CORS via middleware
    app.add_middleware(
        CORSMiddleware,
        allow_credentials=True,
        allow_headers=['*'],
        allow_methods=['*'],
        allow_origins=['*'],
    )

    setup_logging()
    app.add_middleware(LoggingMiddleware)
    # for development
    logger.setLevel(logging.DEBUG)

    app.include_router(api_routes)

    return app


application = create_app()
