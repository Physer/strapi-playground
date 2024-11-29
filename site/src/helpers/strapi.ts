import type { StrapiResponse } from '../models/StrapiResponse';

const { STRAPI_API_TOKEN, STRAPI_BASE_URL } = import.meta.env;

export async function makeRequest(path: string, populateQuery: string = '*'): Promise<StrapiResponse> {
    const response = await fetch(`${STRAPI_BASE_URL}/${path}?populate=${populateQuery}`, {
        headers: {
            Authorization: `Bearer ${STRAPI_API_TOKEN}`,
        },
    });
    if (!response.ok) {
        throw new Error(`Invalid response from the Strapi API: ${response.status}`);
    }

    return (await response.json()) as StrapiResponse;
}
