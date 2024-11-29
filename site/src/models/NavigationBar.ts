import type { StrapiData, StrapiResponse } from './StrapiResponse';

export interface NavigationBar extends StrapiResponse {
    data: NavigationBarData;
}

interface NavigationBarData extends StrapiData {
    Logo: Logo;
    NavigationItems: Array<NavigationItem>;
}

interface Logo extends StrapiData {
    url: string;
}

export interface NavigationItem extends StrapiData {
    Name: string;
    URL: string;
}
