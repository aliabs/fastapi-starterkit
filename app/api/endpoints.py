"""
Primary API route endpoints

"""
from fastapi import APIRouter
from fastapi.logger import logger
from starlette.responses import RedirectResponse


# Init FastAPI router for API endpoints
api_routes = APIRouter()


@api_routes.get('/')
def redirect_to_docs():
    """Redirect to API docs when at site root"""
    return RedirectResponse('/redoc')


@api_routes.get('api/hello/{name}')
async def get_hello(name: str = 'world'):
    logger.debug('DEBUG LOG')
    logger.error('ERROR LOG')
    logger.warning('WARNING LOG')
    logger.info('INFO LOG')
    return dict(hello=name)