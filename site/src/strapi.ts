import { StrapiResponse } from "./models/StrapiResponse";

const { VITE_STRAPI_API_TOKEN, VITE_STRAPI_BASE_URL } = import.meta.env;

export async function makeRequest(
  path: string,
  populateQuery: string = "*"
): Promise<StrapiResponse> {
  const response = await fetch(
    `${VITE_STRAPI_BASE_URL}/${path}?populate=${populateQuery}`,
    {
      headers: {
        Authorization: `Bearer ${VITE_STRAPI_API_TOKEN}`,
      },
    }
  );
  if (!response.ok) {
    throw new Error(`Invalid response from the Strapi API: ${response.status}`);
  }

  return (await response.json()) as StrapiResponse;
}
