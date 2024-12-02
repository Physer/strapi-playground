import type { StrapiData, StrapiResponse } from './StrapiResponse';
import type { Image } from './Image';

export interface NavigationBar extends StrapiResponse {
    data: NavigationBarData;
}

interface NavigationBarData extends StrapiData {
    Logo: Image;
    NavigationItems: Array<NavigationItem>;
}

export interface NavigationItem extends StrapiData {
    Name: string;
    URL: string;
}
