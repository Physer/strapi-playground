import { StrapiData } from "../StrapiResponse";

export interface NavigationBar extends StrapiData {
    Logo: Logo;
    NavigationItems: Array<NavigationItem>;
}

interface Logo extends StrapiData {
    url: string;
}

interface NavigationItem extends StrapiData {
    Name: string;
    URL: string;
}