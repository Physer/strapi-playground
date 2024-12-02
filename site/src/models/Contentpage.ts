import type { RichText } from './RichText';
import type { Image } from './Image';
import type { StrapiData, StrapiResponse } from './StrapiResponse';

export interface Contentpage extends StrapiResponse {
    data: Array<ContentpageData>;
}

export interface ContentpageData extends StrapiData {
    header: string;
    content: Array<RichText>;
    contacts: Array<Image>;
    url: string;
}
