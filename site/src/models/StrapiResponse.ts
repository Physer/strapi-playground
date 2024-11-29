export interface StrapiResponse {
    data: StrapiData;
    meta: StrapiMeta;
}

export interface StrapiData {
    id: number;
    documentId: string;
    createdAt: string;
    updatedAt: string;
    publishedAt: string;
    cmsName?: string;
}

interface StrapiMeta {}
