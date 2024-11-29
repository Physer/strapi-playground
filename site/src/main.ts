import { NavigationBar } from "./models/Components/NavigationBar";
import { Layout } from "./models/Layout";
import { makeRequest } from "./strapi";

const layout = await GetLayout();
GetNavigationBar(layout.navigation_bar.documentId);
GetHomepage();

async function GetLayout(): Promise<Layout> {
  const layout = await makeRequest("layout") as unknown;
  console.log("Layout:", layout);
  return layout as Layout;
}

async function GetNavigationBar(navigationBarId: string) {
    const navigationBar = await makeRequest(`navigation-bars/${navigationBarId}`);
    console.log('Navigation bar:', navigationBar);
}

async function GetHomepage() {
  const homepage = await makeRequest("homepage");
  console.log("Homepage:", homepage);
}
