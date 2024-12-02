import type { Layout } from '../models/Layout';
import type { StrapiResponse } from '../models/StrapiResponse';

const { STRAPI_API_TOKEN, STRAPI_BASE_URL } = import.meta.env;

export async function makeRequest(path: string, populateQuery: string = 'populate=*'): Promise<StrapiResponse> {
    const response = await fetch(`${STRAPI_BASE_URL}/api/${path}?${populateQuery}`, {
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
    return (await makeRequest('layout')) as Layout;
}

export function constructFullCmsUrl(path: string): string {
    return `${import.meta.env.STRAPI_BASE_URL}${path}`;
}
