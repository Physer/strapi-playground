import type { StrapiData, StrapiResponse } from './StrapiResponse';

export interface Layout extends StrapiResponse {
    data: LayoutData;
}

interface LayoutData extends StrapiData {
    navigation_bar: StrapiData;
}
