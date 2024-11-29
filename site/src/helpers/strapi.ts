import type { Layout } from '../models/Layout';
import type { StrapiResponse } from '../models/StrapiResponse';

const { STRAPI_API_TOKEN, STRAPI_BASE_URL } = import.meta.env;

export async function makeRequest(path: string, populateQuery: string = '*'): Promise<StrapiResponse> {
    const response = await fetch(`${STRAPI_BASE_URL}/api/${path}?populate=${populateQuery}`, {
        headers: {
            Authorization: `Bearer ${STRAPI_API_TOKEN}`,
        },
    });
    if (!response.ok) {
        throw new Error(`Invalid response from the Strapi API: ${response.status}`);
    }

    return (await response.json()) as StrapiResponse;
}

export async function getLayout(): Promise<Layout> {
    const layout = (await makeRequest('layout')) as unknown;
    return layout as Layout;
}
