import { makeRequest } from "./strapi";

GetHomepage();

async function GetHomepage() {
    const homepage = await makeRequest('homepage');
    console.log(homepage);
}