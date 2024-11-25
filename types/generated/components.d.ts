import type { Schema, Struct } from '@strapi/strapi';

export interface CustomHero extends Struct.ComponentSchema {
  collectionName: 'components_custom_heroes';
  info: {
    displayName: 'Hero';
    icon: 'picture';
  };
  attributes: {
    BackgroundImage: Schema.Attribute.Media<'images' | 'files'> &
      Schema.Attribute.Required;
    MainImage: Schema.Attribute.Media<'images' | 'files'>;
    Name: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'custom.hero': CustomHero;
    }
  }
}
